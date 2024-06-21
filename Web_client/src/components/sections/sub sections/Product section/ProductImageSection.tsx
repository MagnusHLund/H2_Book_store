import React from 'react'
import Button from '../../../inputs/Button'
import Image from '../../../content/Image'

const handlePrevious = () => {}

const handleNext = () => {}

function ProductImageSection() {
  return (
    <div>
      <div>
        <Button onClick={handlePrevious} placeholder="<" className="" />
        <Image imageSrc="" description="image of book" />
        <Button onClick={handleNext} placeholder=">" className="" />
      </div>
    </div>
  )
}

export default ProductImageSection
