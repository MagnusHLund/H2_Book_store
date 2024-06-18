import React from 'react'
import './QuantityButton.scss'
import Button from './Button'
import TextInput from './TextInput'

interface IQuantityButton {
  defaultValue: string
}

const QuantityButton: React.FC<IQuantityButton> = ({ defaultValue = '' }) => {
  return (
    <div>
      <Button></Button>
      <TextInput placeholder={defaultValue}></TextInput>
      <Button></Button>
    </div>
  )
}

export default QuantityButton
