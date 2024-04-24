import '../scss/Header.scss'
import SearchBox from './SearchBox'
import { LuShoppingBasket } from "react-icons/lu"
import { IconContext } from "react-icons"
import Button from './Button'

function Header() {
    return (
        <div className="header">
            <h1 className="header__logo"> Michael's book club </h1>
            <SearchBox placeholder=' 🔎 Hamlet by William Shakespeare '/>
            <div className='header__loginAndButton'>
                <IconContext.Provider value={{ size:'3vh'}}>
                    <LuShoppingBasket className='header__buttonContainer__icon'/>
                </IconContext.Provider>
                <Button placeholder='Log in'/>
            </div>
        </div>
    )
}

export default Header