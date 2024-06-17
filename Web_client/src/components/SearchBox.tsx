import './SearchBox.scss'

interface ISearchBox {
    placeholder?: string
}

const SearchBox: React.FC<ISearchBox> = ({ placeholder }) => {
    return (
        <div className="searchBox">
            <input type="text" placeholder={ placeholder }  className="searchBox__search"></input>
        </div>
    )
}

export default SearchBox