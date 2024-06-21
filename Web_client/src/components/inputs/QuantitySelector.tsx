import React, { useState } from 'react'
import './QuantitySelector.scss'
import Button from './Button'
import TextInput from './TextInput'

interface IQuantitySelector {
  defaultValue: string
}

const MIN_QUANTITY = 1

const QuantitySelector: React.FC<IQuantitySelector> = ({ defaultValue }) => {
  // Initialize state with the default value parsed as an integer
  const [quantity, setQuantity] = useState<number>(parseInt(defaultValue, 10))

  // Handle increment action
  const handleIncrement = () => {
    setQuantity((prevQuantity) => prevQuantity + 1)
  }

  // Handle decrement action
  const handleDecrement = () => {
    setQuantity((prevQuantity) => Math.max(MIN_QUANTITY, prevQuantity - 1))
  }

  // Handle input change
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = parseInt(e.target.value, 10)
    if (!isNaN(newValue) && newValue >= MIN_QUANTITY) {
      setQuantity(newValue)
    } else if (newValue < MIN_QUANTITY) {
      setQuantity(MIN_QUANTITY)
    }
  }

  return (
    <div className="quantity-selector">
      <Button
        onClick={handleDecrement}
        placeholder="-"
        className="quantity-selector__button--left"
      />
      <TextInput
        value={quantity.toString()}
        onChange={handleInputChange}
        placeholder={quantity.toString()}
        type="text"
        className="text-input__box"
      />
      <Button
        onClick={handleIncrement}
        placeholder="+"
        className="quantity-selector__button--right"
      />
    </div>
  )
}

export default QuantitySelector
