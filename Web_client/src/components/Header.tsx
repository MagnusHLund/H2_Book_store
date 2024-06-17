import './Header.scss'
import SearchBox from './SearchBox'
import Image from './Image'
import Button from './Button'
import { LuShoppingBasket } from "react-icons/lu"
import { IconContext } from "react-icons"

function Header() {
    return (
        <div className="header">
            <div className='header__logo'>
                <Image imageSrc='DavidsBookClub.png'></Image>
            </div>
            <SearchBox placeholder=' 🔎 Hamlet by William Shakespeare '/>
            <div className='header__loginAndButton'>
                <IconContext.Provider value={{ size:'3vh', style: { verticalAlign: 'middle', cursor:'pointer' }}}>
                    <LuShoppingBasket className='header__buttonContainer__icon'/>
                </IconContext.Provider>
                <Button placeholder='Log in'/>
            </div>
        </div>
    )
}

export default Header