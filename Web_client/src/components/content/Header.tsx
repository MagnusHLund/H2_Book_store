import './Header.scss'
import SearchBox from '../inputs/SearchBox'
import Image from './Image'
import Basket from "./Basket.tsx"
import Button from "../inputs/Button.tsx"
import {useState} from "react"

function Header() {
    
    const [isBasketVisible, setIsBasketVisible] = useState(false)

    const toggleBasket = () => {
        setIsBasketVisible(!isBasketVisible)
    }
    
  return (
    <div className="header">
      <div className="header__logo">
        <Image imageSrc="DavidsBookClub.png"></Image>
      </div>
      <SearchBox placeholder=" 🔎 Hamlet by William Shakespeare " />
        <div className="header__basket-and-login">
            <div className="header__basket-and-login__basket">
                <Basket toggleBasket={toggleBasket}/>
            </div>
            <Button placeholder="Log In"/>
        </div>
    </div>
  )
}

export default Header
