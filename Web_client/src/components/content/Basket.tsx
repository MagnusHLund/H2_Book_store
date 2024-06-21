import { IconContext } from 'react-icons'
import { LuShoppingBasket } from 'react-icons/lu'
import Button from '../inputs/Button.tsx'
import cn from 'classnames'
import './Basket.scss'
import React, { useState } from 'react'
import BasketItem from "./BasketItem.tsx"

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
            <div className={cn('basket-container', {
                'basket-container__not-visible': !isBasketVisible,
            })}>
                <h2> Items in basket: </h2>
                <div className='basket-container__products-container'>
                    <BasketItem></BasketItem>
                </div>
            </div>
        </>
    )
}

const BasketIcon: React.FC<BasketProps> = ({toggleBasket}) => {
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
