<?php

namespace DavidsBookClub\Handlers;

use DavidsBookClub\Utils\Database;

class OrdersController
{
    public function getOrders()
    {
        /** TODO:
         * Lazy loading which calls a stored procedure with a range of rows to return to the API.
         * The API then returns the response from the SP, to the API caller.
         */
    }

    public function verifyCoupon($couponInput)
    {
    }

    public function searchOrders($searchInput)
    {
    }

    public function getUserOrders()
    {
    }

    public function getCityFromZipCode()
    {
    }

    public function createOrder()
    {
    }
}
