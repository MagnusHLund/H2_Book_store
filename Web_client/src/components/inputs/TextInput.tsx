import { StandardInputProps } from './StandardInputProps'
import './TextInput.scss'

interface TextInputProps extends StandardInputProps {
  placeholder: string
  type?: 'email' | 'text' | 'number'
  className?: string
}

const TextInput: React.FC<TextInputProps> = ({
  placeholder,
  type = 'text',
  className = '',
}) => {
  return (
    <input
      type={type}
      placeholder={placeholder}
      className={`text-input ${className}`}
    />
  )
}

export default TextInput
