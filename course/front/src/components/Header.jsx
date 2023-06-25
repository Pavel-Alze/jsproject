import '../styles/index.css'
import {Link} from 'react-router-dom'

function Header(){
    return(
     <header>   
        <Link to='/' className='indexlink'>
            <img className='logo' src='../../logo.svg'/>
        </Link>
    </header>
    );
}
export default Header;