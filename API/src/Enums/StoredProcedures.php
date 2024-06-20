<?php

use DavidsBookClub\enums;

enum storedProcedures
{
    case CheckEmailUnique;
    case CheckUserPhoneExists;
    case CreateGuestAccount;
    case CreateUser;
    case GetCityByZipCode;
    case GetOrderDetails;
    case GetFilteredOrderDetails;
    case GetProductById;
    case GetProducts;
    case GetUserInformation;
    case GetUserOrdersDetails;
    case SearchProducts;
    case InsertOrder;
    case ToggleProductVisibility;
    case ValidateProduct;
    case VerifyCoupon;
}
