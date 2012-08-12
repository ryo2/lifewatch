require 'test_helper'

class LiverecordsControllerTest < ActionController::TestCase
  setup do
    @liverecord = liverecords(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:liverecords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create liverecord" do
    assert_difference('Liverecord.count') do
      post :create, liverecord: { deleted_at: @liverecord.deleted_at, end: @liverecord.end, start: @liverecord.start, task_id: @liverecord.task_id, type_id: @liverecord.type_id, user_id: @liverecord.user_id }
    end

    assert_redirected_to liverecord_path(assigns(:liverecord))
  end

  test "should show liverecord" do
    get :show, id: @liverecord
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @liverecord
    assert_response :success
  end

  test "should update liverecord" do
    put :update, id: @liverecord, liverecord: { deleted_at: @liverecord.deleted_at, end: @liverecord.end, start: @liverecord.start, task_id: @liverecord.task_id, type_id: @liverecord.type_id, user_id: @liverecord.user_id }
    assert_redirected_to liverecord_path(assigns(:liverecord))
  end

  test "should destroy liverecord" do
    assert_difference('Liverecord.count', -1) do
      delete :destroy, id: @liverecord
    end

    assert_redirected_to liverecords_path
  end
end
