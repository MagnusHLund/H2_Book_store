import React, { useState } from 'react'
import './QuantitySelector.scss'
import Button from './Button'
import TextInput from './TextInput'

interface IQuantitySelector {
  defaultValue: string
}

const QuantitySelector: React.FC<IQuantitySelector> = ({ defaultValue }) => {
  // Initialize state with the default value parsed as an integer
  const [quantity, setQuantity] = useState<number>(parseInt(defaultValue, 10))

  // Handle increment action
  const handleIncrement = () => {
    setQuantity((prevQuantity) => prevQuantity + 1)
  }

  // Handle decrement action
  const handleDecrement = () => {
    setQuantity((prevQuantity) => Math.max(1, prevQuantity - 1))
  }

  // Handle input change
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = parseInt(e.target.value, 10)
    if (!isNaN(newValue) && newValue >= 1) {
      setQuantity(newValue)
    } else if (newValue < 1) {
      setQuantity(1)
    }
  }

  return (
    <div className="quantity-selector">
      <Button
        onClick={handleDecrement}
        placeholder="-"
        className="quantity-selector__button--left"
      ></Button>
      <TextInput
        value={quantity.toString()}
        onChange={handleInputChange}
        placeholder={quantity.toString()}
        type="text"
        className="text-input_box"
      />
      <Button
        onClick={handleIncrement}
        placeholder="+"
        className="quantity-selector__button--right"
      ></Button>
    </div>
  )
}

export default QuantitySelector
