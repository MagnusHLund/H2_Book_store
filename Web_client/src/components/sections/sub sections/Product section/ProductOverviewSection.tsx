import React from 'react'
import QuantitySelector from '../../../inputs/QuantitySelector'

function ProductOverviewSection() {
  return (
    <div>
      <div>
        <h2>Product name</h2>
        <h3>Author name</h3>
        <h4>Category</h4>
        <h4>Genre</h4>
        <h3>Price</h3>
        <div>
          <QuantitySelector defaultValue="1" />
        </div>
      </div>
    </div>
  )
}

export default ProductOverviewSection
