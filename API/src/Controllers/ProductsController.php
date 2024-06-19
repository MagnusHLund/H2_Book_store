<?php

namespace DavidsBookClub\Controllers;

use DavidsBookClub\Utils\Database;
use DavidsBookClub\Utils\MessageManager;

class ProductsController
{
    /**
     * This function gets products for the home page.
     * @param object $payload `$Payload->totalReceivedItems` is used to keep track of how many rows of products have been displayed.
     *               `$payload->limit` is used  to determine how many products should be returned to the front.
     */
    public function getProducts($payload)
    {
        if (isset($payload->totalReceivedItems, $payload->limit)) {
            // Call SP to get more products, based on the $payload values of which rows to return and how many.
            // The SP returns productIds, one image, product name and price.

            $products = "";
            MessageManager::sendSuccess($products);
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function gets all information on a single product.
     * @param object $payload `$payload->productId` is used to identify the product, which has to be fetched.
     */
    public function getProductById($payload)
    {
        if (isset($payload->productId)) {
            // Call SP with the productId parameter

            $SpInfo = "";
            if (isset($SpInfo)) {
                // If the product exists then it returns product information
                MessageManager::sendSuccess($SpInfo);
            } else {
                MessageManager::sendError("No product found", 404);
            }
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function searches for products and returns products that match the search input.
     * @param object $payload `$payload->limit` is used to determine how many products should be returned.
     *                        `$payload->searchInput` is the input which should be searched for.
     */
    public function searchProducts($payload)
    {
        if (isset($payload->searchInput, $payload->limit)) {
            // Calls SP to find matches for the search input.

            $products = "";
            MessageManager::sendSuccess($products);
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function toggles if a book should be shown or not.
     * @param object $payload `$payload->bookId` is used to identify the book that should change its display state.
     */
    public function toggleBookDisplay($payload)
    {
        if (isset($payload->bookId)) {
            // Call SP to change the state of the book.
        } else {
            MessageManager::missingParameters();
        }
    }
}
