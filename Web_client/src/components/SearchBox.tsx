import './SearchBox.scss'

interface ISearchBox {
    placeholder?: string
}

const SearchBox: React.FC<ISearchBox> = ({ placeholder = "" }) => {
    return (
        <div className="search-box">
            <input type="text" placeholder={ placeholder }  className="search-box__search"></input>
        </div>
    )
}

export default SearchBox