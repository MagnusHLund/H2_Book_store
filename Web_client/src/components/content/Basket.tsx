import { IconContext } from 'react-icons'
import { LuShoppingBasket } from 'react-icons/lu'
import Button from '../inputs/Button.tsx'
import './Basket.scss'
import React, { useState } from 'react'

interface BasketProps {
    toggleBasket: () => void
}

const Basket: React.FC<BasketProps> = ({ toggleBasket }) => {
    const [isBasketVisible, setIsBasketVisible] = useState(false)
    const handleToggleBasket = () => {
        setIsBasketVisible(!isBasketVisible)
        toggleBasket()
    }

    return (
        <>
            <BasketIcon toggleBasket={handleToggleBasket} />
            {isBasketVisible && (
                <div className="basket-container basket-container__scale-in-top">
                    <p>Your basket is visible now!</p>
                    <p>Your basket is visible now!</p>
                    <p>Your basket is visible now!</p>
                    <p>Your basket is visible now!</p>
                    <p>Your basket is visible now!</p>
                </div>
            )}
        </>
    )
}

const BasketIcon: React.FC<BasketProps> = ({ toggleBasket }) => {
    return (
        <Button transparent={true} onClick={toggleBasket}>
            <IconContext.Provider
                value={{
                    size: '3vh',
                    style: { verticalAlign: 'middle', color: 'black' },
                }}
            >
                <LuShoppingBasket />
            </IconContext.Provider>
        </Button>
    )
}

export default Basket
