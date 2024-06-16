<?php

namespace DavidsBookClub\Utils;

use DavidsBookClub\Handlers\ProductsController;
use DavidsBookClub\Handlers\OrdersController;
use DavidsBookClub\Handlers\UsersController;

class Router
{
    // This variable holds all the routes for the API. For example: /api/v1/users/createUser
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "/api/v1/";
        $users = $baseUrl . "users/";
        $orders = $baseUrl . "orders/";
        $products = $baseUrl . "products/";

        /**
         * Each route consists of 3 mandatory parts and 1 optional part:
         * 1. The request type, which for this API is either "GET" or "POST".
         * 2. The API call itself, which could be /api/v1/users/getUserBillingInfo
         * 3. An array, which holds the class (instance) and function (string) which should be called.
         * 4. (Optional) An array, which holds the request body. Used for calling a function with a parameter. 
         *    Within the routes variable, it has a placeholder value of "requestBody", which will be overridden.
         */
        $this->routes = [
            // User routes
            ["GET", $users . "getUserBillingInfo", [(new UsersController), "getUserBillingInfo"]],
            ["POST", $users . "createUser", [(new UsersController), "createUser"], ["requestBody"]],
            ["POST", $users . "loginUser", [(new UsersController), "loginUser"], ["requestBody"]],
            ["POST", $users . "logoutUser", [(new UsersController), "logoutUser"]],

            // Order routes
            ["GET", $orders . "getOrders", [(new OrdersController), "getOrders"]],
            ["GET", $orders . "getUserOrders", [(new OrdersController), "getUserOrders"]],
            ["GET", $orders . "getCityFromZipCode", [(new OrdersController), "getCityFromZipCode"]],
            ["GET", $orders . "verifyCoupon", [(new OrdersController), "verifyCoupon"], ["requestBody"]],
            ["GET", $orders . "searchOrders", [(new OrdersController), "searchOrders"], ["requestBody"]],
            ["POST", $orders . "createOrder", [(new OrdersController), "createOrder"]],

            // Product routes
            ["GET", $products . "getProducts", [(new ProductsController), "getProducts"]],
            ["GET", $products . "getProduct", [(new ProductsController), "getProduct"], ["requestBody"]],
            ["GET", $products . "searchProducts", [(new ProductsController), "searchProducts"], ["requestBody"]],
            ["POST", $products . "toggleBookDisplay", [(new ProductsController), "toggleBookDisplay"]],
        ];
    }

    /**
     * This function maps the API call, to a specific function. If no route is found, an error is sent to the caller.
     * @param string $method The request method type used to call the API. It can be either "GET" or "POST".
     * @param string $path The API call itself, which could be /api/v1/products/getProduct for example.
     * @param array<string,mixed> $requestBody The body of the API call.
     */
    public function handleRequest($method, $path, $requestBody)
    {
        foreach ($this->routes as $route) {
            // Assigns new variables, which are more readable than array items.
            $routeMethod = $route[0];
            $routePath = strtolower($route[1]);
            $handler = $route[2];
            $params = $route[3] ?? [];

            // If the network request method and path matches, then it calls a specific class.
            if ($method === $routeMethod && strtolower($path) === $routePath) {
                call_user_func_array([$handler[0], $handler[1]], [[$requestBody], $params]);
                return;
            }
        }

        // If no route matches the API call, then an error is sent to the caller.
        MessageManager::sendError("This route does not exist!", 404);
        exit;
    }
}
