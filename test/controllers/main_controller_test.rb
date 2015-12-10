require 'test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:erik)
  end

  test 'should return the home page' do
    get :index
    assert_response :success
    assert_select 'title', 'Pledge-to-Donate'
    assert_select 'p#tagline', 'This giving season and beyond, consider pledging to donate your Food, Toys or even just your time to one of these many Food Pantries in and around Ventura County.'
  end

  test 'should show search form when signed in' do
    sign_in @user
    get :index
    assert_response :success
    assert_select 'form' do
      assert_select '[action=?]', '/address'
      assert_select '[method=?]', 'get'
    end
    assert_select 'label#city_state_label', 'City'
    assert_select 'select#city_state' do
      assert_select 'option', 'Camarillo, California'
    end
    assert_select 'label#address_label', 'Address, Neighborhood'
    assert_select 'input#address', true
    assert_select 'input[name="commit"]' do
      assert_select '[type=?]', 'submit'
      assert_select '[value=?]', 'Find Food Drives'
    end
    assert_select 'div#map', true
  end
end
