import './ProductAdditionalInfoSection.scss'

function ProductAdditionalInfoSection() {
  return (
    <div className="ProductInfo">
      <div className="ProductInfo-point">
        <h4>ISBN:</h4>
        <h4>Release date:</h4>
        <h4>Language:</h4>
      </div>
      <div className="ProductInfo-text">
        <p>54373293824</p>
        <p>12/05/2008</p>
        <p>Danish</p>
      </div>
    </div>
  )
}

export default ProductAdditionalInfoSection
