# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:one)
  end

  test 'should get index when logged in' do
    sign_in @user
    get repositories_url
    assert_response :success
    assert { response.body.include?(@repository.full_name) }
  end

  test 'should redirect index when not logged in' do
    get repositories_url
    assert_redirected_to root_path
  end

  test 'should get new' do
    sign_in @user
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    sign_in @user

    assert_difference('Repository.count', 1) do
      post repositories_url, params: { repository: { github_id: 453_780 } }
    end

    assert_redirected_to repositories_path

    created = Repository.last
    assert { created.name == 'test-repo' }
    assert { created.full_name == 'user/test-repo' }
    assert { created.language == 'Ruby' }
    assert { created.user == @user }
  end

  test 'should not create copies of repository' do
    sign_in @user

    assert_no_difference('Repository.count') do
      post repositories_url, params: { repository: { github_id: @repository.github_id } }
    end
  end

  test 'should get show' do
    sign_in @user
    get repository_url(@repository)
    assert_response :success
  end

  test 'should redirect show when not logged in' do
    get repository_url(@repository)
    assert_redirected_to root_path
  end

  test 'should see only owned repositories' do
    other_repo = Repository.create!(
      name: 'other-repo', github_id: 777_777,
      full_name: 'other/other-repo', language: 'Ruby',
      clone_url: 'https://github.com/other/other-repo.git',
      ssh_url: 'git@github.com:other/other-repo.git',
      user: users(:two)
    )

    sign_in @user
    get repositories_url
    assert_response :success
    assert { response.body.include?(@repository.full_name) }
    assert { response.body.exclude?(other_repo.full_name) }
  end
end
