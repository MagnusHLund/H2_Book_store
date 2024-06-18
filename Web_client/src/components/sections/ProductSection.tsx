import './ProductSection.scss'
import ProductImageSection from './sub sections/Product section/ProductImageSection'
import ProductAdditionalInfoSection from './sub sections/Product section/ProductAdditionalInfoSection'
import ProductOverviewSection from './sub sections/Product section/ProductOverviewSection'

function ProductSection() {
  return (
    <>
      <div className="product-section__upper">
        <div className="product-section__upper__pic">
          <ProductImageSection />
        </div>
        <div className="product-section__upper__info">
          <ProductOverviewSection />
          <div className="product-section"></div>
        </div>
      </div>
      <div className="product-section__lower">
        <ProductAdditionalInfoSection />
      </div>
    </>
  )
}

export default ProductSection
