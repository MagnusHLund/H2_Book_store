<?php

namespace DavidsBookClub\Utils;

use DavidsBookClub\Handlers\ProductsHandler;
use DavidsBookClub\Handlers\OrdersHandler;
use DavidsBookClub\Handlers\UsersHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/v1/";
        $users = $baseUrl . "users/";
        $orders = $baseUrl . "orders/";
        $products = $baseUrl . "products/";

        $this->routes = [
            // User routes
            ["GET", $users, [(new UsersHandler), "getUserBillingInfo"]],
            ["POST", $users, [(new UsersHandler), "createUser"]],
            ["POST", $users, [(new UsersHandler), "logoutUser"]],
            ["POST", $users, [(new UsersHandler), "loginUser"]],

            // Order routes
            ["GET", $orders, [(new OrdersHandler), "getOrders"]],
            ["GET", $orders, [(new OrdersHandler), "verifyCoupon"]],
            ["GET", $orders, [(new OrdersHandler), "searchOrders"]],
            ["GET", $orders, [(new OrdersHandler), "getUserOrders"]],
            ["GET", $orders, [(new OrdersHandler), "getCityFromZipCode"]],
            ["POST", $orders, [(new OrdersHandler), "createOrder"]],

            // Product routes
            ["GET", $products, [(new ProductsHandler), "getProduct"]],
            ["GET", $products, [(new ProductsHandler), "getProducts"]],
            ["GET", $products, [(new ProductsHandler), "searchProducts"]],
            ["POST", $products, [(new ProductsHandler), "toggleBookDisplay"]],
        ];
    }


    public function handleRequest($method, $path, $requestBody)
    {
        foreach ($this->routes as $route) {
            $routeMethod = $route[0];
            $routePath = $route[1];
            $handler = $route[2];
            $params = $route[3] ?? [];

            if ($method === $routeMethod && $path === $routePath) {
                call_user_func_array([$handler[0], $handler[1]], [[$requestBody], $params]);
                return;
            }
        }

        http_response_code(404);
        echo json_encode(["error" => "This route does not exist!"]);
        exit;
    }
}
