import { StandardInputProps } from './StandardInputProps'
import './TextInput.scss'

interface TextInputProps extends StandardInputProps {
  placeholder: string
  type?: 'email' | 'text' | 'number'
  className?: string
  value: string
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void
}

const TextInput: React.FC<TextInputProps> = ({
  placeholder,
  type = 'text',
  className = '',
  value,
  onChange,
}) => {
  return (
    <input
      type={type}
      placeholder={placeholder}
      className={`text-input ${className}`}
      value={value}
      onChange={onChange}
    />
  )
}

export default TextInput
