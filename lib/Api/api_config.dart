class ApiConfig {
  @override
  noSuchMethod(Invocation invocation) async {
    return super.noSuchMethod(invocation);
  }

  // final key_auth = 'Authorization';
  final x_api_key = 'X-API-KEY';
  final x_api_key_value = 'AYTTRACK@12345678';

  final content_type = 'Authorization';
  final content_type_value = 'Basic YXl0YWRtaW46MTIzNDU2Nzg=';


  String baseurl = "https://technolite.in/staging/asdadmin/";


  String api_login = "api/login";
  String api_register = "api/register";
  String api_otp = "api/send_otp";
  String api_getProfile = "api/me";
  String api_categories = "api/categories";
  String api_sub_categories = "api/sub-categories?sub_category_id=";
  String api_plans = "api/plans";
  String api_update = "api/update";
  String api_logout = "api/logout";
  String api_refresh = "api/refresh";
  String api_forget_otp = "api/password/forgot/otp";
  String api_SubmitNewPass = "api/password/forgot?id=";
  String api_follow_seller = "api/seller/follow?seller_id=";
  String api_purchase_plan = "api/user/plan?plan_id=";
  String api_getAll_seller = "api/sellers?page=1&&limit=";
  String api_getAll_seller_page = "api/sellerwithproducts?page=";
  String api_product_seller = "api/products/seller?page=";
  String api_seller_product = "api/user/products?page=1&limit=";
  String api_order_history = "api/orders";
  String api_cancel_order = "api/orders/cancel?order_id=";
  String api_update_address = "api/user/address";
  String api_product_Detail = "api/product?product_id=";
  String api_product_like = "api/products/like?product_id=";
  String api_add_to_cart = "api/products/cart?product_id=";
  String api_cart_detail = "api/products/cart";
  String api_purchase_prod = "api/products/purchase?payment_status=";
  String api_remove_cart = "api/products/cart/remove?cart_id=";
  String api_add_product = "api/products/add";
  String api_add_product_Images = "api/products/image?product_id=";
  String api_rating_review = "api/rating?order_id=";
  String api_following = "api/followings";
  String api_followers = "api/followers";
  String api_liked_prod = "api/products/likes?page=1&limit=5";
  String api_popular_product = "api/products/popular";
  String api_liked_paging = "api/products/likes?page=";
  String api_change_password = "api/password/change";
  String api_notification = "api/user/notifications";
  String api_search = "api/user?searchTerm=";
  String api_my_order = "api/seller/orders?limit";
  String api_accept_order = "api/orders/accept?order_id=";
  String api_chat = "api/getMessageWithUser";
  String api_getMessage = "api/getMessageDetails?receive_id=";
  String api_sendMessage = "api/messages?seller_id=";


}
