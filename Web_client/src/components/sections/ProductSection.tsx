import ProductImageSection from './sub sections/Product section/ProductImageSection'
import ProductAdditionalInfoSection from './sub sections/Product section/ProductAdditionalInfoSection'
import ProductOverviewSection from './sub sections/Product section/ProductOverviewSection'

function ProductSection() {
  return (
    <div className="product-section">
      <div className="product-section__upper">
        <ProductImageSection />
        <ProductOverviewSection />
      </div>

      <div className="product-section__lower">
        <ProductAdditionalInfoSection />
      </div>
    </div>
  )
}

export default ProductSection
