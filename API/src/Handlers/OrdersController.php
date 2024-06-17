<?php

namespace DavidsBookClub\Handlers;

use DavidsBookClub\Utils\Database;
use DavidsBookClub\Utils\MessageManager;
use DavidsBookClub\Utils\SecurityManager;

class OrdersController
{
    /**
     * This function returns orders, for the admin panel.
     * It gets called with lazy loading, so it only returns some items at a time.
     * @param object $payload This parameter holds how many times have been returned so far, to the API caller.
     */
    public function getOrders($payload)
    {
        $RowsToReturn = 12;

        /** TODO:
         * Lazy loading which calls a stored procedure with a range of rows to return to the API.
         * The API then returns the response from the SP, to the API caller.
         */

        if (isset($payload->totalReceivedItems)) {
            // Call SP, which gets the amount of total received items and how many to return
            // Then the SP returns the next 12 rows.

            if (true) {
                // If any rows are returned then they get returned to the API caller here
                $arrayOfRows = "";
                MessageManager::sendSuccess($arrayOfRows);
            }
        } else {
            MessageManager::sendError("No orders left to return", 404);
        }
    }


    /**
     * This function checks if the coupon from the checkout is valid, for the webshop.
     * @param object $payload This parameter is the coupon input from the API caller. It can be retrieved with $payload->coupon.
     */
    public function verifyCoupon($payload)
    {
        if (isset($payload->coupon)) {
            $securityManager = new SecurityManager;

            // Call SP to get all encrypted coupons

            foreach ($CouponsInDatabase as $coupon) {
                // Decrypt each coupon until a match is found
                $securityManager->decryptData($coupon);

                // If match is found for coupon
                if (true) {
                    MessageManager::sendSuccess("Valid coupon code");
                    exit;
                }
            }
        }

        MessageManager::sendError("Invalid coupon code", 404);
    }

    public function searchOrders($searchInput)
    {
    }

    public function getUserOrders($userId)
    {
    }

    public function getCityFromZipCode($zipCode)
    {
    }

    public function createOrder($orderInfo)
    {
    }
}
