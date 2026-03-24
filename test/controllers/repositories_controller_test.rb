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
    github_repos = [stub_github_repo]

    Octokit::Client.stub(:new, stub_client(github_repos)) do
      get new_repository_url
      assert_response :success
    end
  end

  test 'should create repository' do
    sign_in @user
    repo = stub_github_repo(
      id: 999_999,
      name: 'new-repo',
      full_name: 'user/new-repo',
      language: 'Ruby',
      clone_url: 'https://github.com/user/new-repo.git',
      ssh_url: 'git@github.com:user/new-repo.git'
    )

    Octokit::Client.stub(:new, stub_client([repo])) do
      assert_difference('Repository.count', 1) do
        post repositories_url, params: { repository: { github_id: repo.id } }
      end
    end

    assert_redirected_to repositories_path

    created = Repository.last
    assert { created.name == 'new-repo' }
    assert { created.full_name == 'user/new-repo' }
    assert { created.language == 'Ruby' }
    assert { created.github_id == 999_999 }
    assert { created.user == @user }
  end

  test 'should not create copies of repository' do
    sign_in @user
    repo = stub_github_repo(id: @repository.github_id)

    Octokit::Client.stub(:new, stub_client([repo])) do
      assert_no_difference('Repository.count') do
        post repositories_url, params: { repository: { github_id: repo.id } }
      end
    end
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

  private

  def stub_github_repo(attrs = {})
    defaults = {
      id: 123_456,
      name: 'test-test',
      full_name: 'Test/test-test',
      language: 'Ruby',
      clone_url: 'https://github.com/Test/test-test.git',
      ssh_url: 'git@github.com:Test/test-test.git'
    }
    OpenStruct.new(defaults.merge(attrs))
  end

  def stub_client(repos)
    client = Minitest::Mock.new
    client.expect(:repos, repos)
    client.expect(:repos, repos)
    client
  end
end
