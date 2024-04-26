<?php

namespace MichaelsBookClub\Utils;

use MichaelsBookClub\Handlers\UserHandler;
use MichaelsBookClub\Handlers\ProductHandler;
use MichaelsBookClub\Handlers\OrderHandler;
use MichaelsBookClub\Handlers\CheckoutHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/";

        $userHandler = new UserHandler;

        $userRoute = "User/";

        $productHandler = new ProductHandler;

        $productRoute = "Products/";

        $orderHandler = new OrderHandler;

        $orderRoute = "Orders/";

        $checkoutHandler = new CheckoutHandler;

        $checkoutRoute = "Checkout/";
        
        

        // Routes are made up in 3 parts. 1. Request type, 2. API url, 3. function to call
        $this->routes = [
            // Login
            ["POST", $baseUrl . $userRoute . "login", [$userHandler, "login"]],
            
            // Logout
            ["POST", $baseUrl . $userRoute . "logout", [$userHandler, "logout"]],

            // Create
            ["GET", $baseUrl . $userRoute . "create", [$userHandler, "CreateUser"]],
            
            // Update
            ["PUT", $baseUrl . $userRoute . "create/{id}", [$userHandler, "updateUser"]],

            // Delete
            ["DELETE", $baseUrl . $userRoute . "create", [$userHandler, "deleteUser"]]


            
        ];

        $this->routes = [
            // Product
            ["POST", $baseUrl . $productRoute . "Product", [$productHandler, "Product"]],
            
            // Get product
            ["GET", $baseUrl . $productRoute . "product", [$productHandler, "getProduct"]],

            // Create product
            ["POST", $baseUrl . $productRoute . "product", [$productHandler, "createProduct"]],
            
            // Update product
            ["PUT", $baseUrl . $productRoute . "product/{id}", [$productHandler, "updateProduct"]],
            
            // Delete product
            ["DELETE", $baseUrl . $productRoute . "product/{id}", [$productHandler, "deleteProduct"]]
        ];

        $this->routes = [
            // Order
            ["POST", $baseUrl . $orderRoute . "order", [$orderHandler, "order"]],
            
            // Get Order by ID
            ["GET", $baseUrl . $orderRoute . "order/{id}", [$orderHandler, "getOrderById"]],
            
            // Get All Orders
            ["GET", $baseUrl . $orderRoute . "order", [$orderHandler, "getAllOrders"]]
        ];

        $this->routes = [
            // Checkout - Place Order
            ["POST", $baseUrl . $checkoutRoute . "placeOrder", [$checkoutHandler, "placeOrder"]]
        ];
    }


    public function handleRequest($method, $path, $requestBody)
    {
        foreach ($this->routes as $route) {
            list($routeMethod, $routePath, $handler, $params) = $route + [null, null, null, []];
            if ($method === $routeMethod && $path === $routePath) {
                call_user_func_array([$handler[0], $handler[1]], [[$requestBody], $params]);
                return;
            }
        }

        http_response_code(404);
        echo json_encode(["error" => "Route does not exist!"]);
        exit;
    }
}
