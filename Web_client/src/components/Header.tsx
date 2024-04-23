import '../scss/Header.scss'
import SearchBox from './SearchBox'
import Button from './Button'

function Header() {

    return(
        <div className="header">
            <h1 className="header__logo"> Test </h1>
            <SearchBox placeholder=' Hamlet by William Shakespeare '/>
            <Button placeholder='Log in'/>
        </div>
    )
}

export default Header