import React from 'react'
import './QuantityButton.scss'
import Button from './Button'
import TextInput from './TextInput'

interface IQuantitySelector {
  defaultValue: string
}

const QuantitySelector: React.FC<IQuantitySelector> = ({ defaultValue }) => {
  const fgfggf = () => {}
  return (
    <div>
      <Button onClick={fgfggf}>-</Button>
      <TextInput placeholder={defaultValue}></TextInput>
      <Button>+</Button>
    </div>
  )
}

export default QuantitySelector
