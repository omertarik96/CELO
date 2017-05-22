import React from 'react';
import $ from 'jquery';

import Heading from './Heading.jsx';
import Content from './Content.jsx';
import Footer from './Footer.jsx';

class App extends React.Component {

    constructor(props) {
        super(props);

        this.state={headingTitle:"SHRPAS Home"};

    }
    setHeadingTitle(title){
        this.setState({headingTitle:title});
    }
    render() {
        return (
            <div className="">
                <Content OnRequestApp={()=>{return this;}}/>
                <Footer/>
            </div>

        )
    }
}

export default App;