import React from 'react';
import './BoughtProducts.scss';

interface IBoughtProducts {
  name: string;
  image: string;
  price: number;
}

interface IAggregatedProduct extends IBoughtProducts {
  count: number;
}

const purchasedProducts: IBoughtProducts[] = [ 
  {
    image: "https://image.bog-ide.dk/4870012-1137906-1000-665/webp/0/640/4870012-1137906-1000-665.webp",
    name: "Skygger På Silkevejen", 
    price: 229.95,
  },
  {
    image: "https://image.bog-ide.dk/4870012-1137906-1000-665/webp/0/640/4870012-1137906-1000-665.webp",
    name: "Skygger På Silkevejen", 
    price: 229.95,
  },
  {
    image: "https://image.bog-ide.dk/4870012-1137906-1000-665/webp/0/640/4870012-1137906-1000-665.webp",
    name: "Skygger På Silkevejen", 
    price: 229.95,
  },
  {
    image: "https://image.bog-ide.dk/4870012-1137906-1000-665/webp/0/640/4870012-1137906-1000-665.webp",
    name: "Skygger På Silkevejen", 
    price: 229.95,
  },

  {
    image: "https://image.bog-ide.dk/4300066-692754-1000-624/webp/0/640/4300066-692754-1000-624.webp",
    name: "Vane Dyr", 
    price: 259.95,
  },
  {
    image: "https://image.bog-ide.dk/4521994-879043-1000-677/webp/0/640/4521994-879043-1000-677.webp",
    name: "Kan Man Tænke Sig Rask", 
    price: 299.95,
  },
];

function aggregateProducts(products: IBoughtProducts[]): IAggregatedProduct[] {
  const aggregated: Record<string, IAggregatedProduct> = {};

  products.forEach(product => {
    if (aggregated[product.name]) {
      aggregated[product.name].count += 1;
    } else {
      aggregated[product.name] = { ...product, count: 1 };
    }
  });

  return Object.values(aggregated);
}

function BoughtProducts() {
  const aggregatedProducts = aggregateProducts(purchasedProducts);

  return (
    <div className="bought-products">
      {aggregatedProducts.map((product, index) => (
        <div key={index} className="product-item">
          <img className="product-image" src={product.image} alt={product.name} />
          <div className="product-details">
            <label className="product-name">{product.name}</label>
            <br></br>
            <label className="product-price">{product.price.toFixed(2)} DKK</label>
            {product.count > 1 && <span className="product-count">x{product.count}</span>}
          </div>
        </div>
      ))}
    </div>
  );
}

export default BoughtProducts;
