import '../styles/index.css'
import {Link, useNavigate} from 'react-router-dom'
import React from 'react';
import { useState, useEffect } from 'react';
import { Modal, Button, Form, Input } from 'antd';
import axios, { Axios } from "axios"
import {GeolocationControl, Map, Placemark, SearchControl, useYMaps, YMaps, ZoomControl} from "@pbe/react-yandex-maps";




function Main(){

    const [dataSource, setdataSource] = useState([]);

    const onGetAll = async () => {
        await axios.get('http://localhost:8081/places', {
            headers: {
              token: localStorage.getItem("token"),
            },
          }).then((res) => {
                const DbList = res.data.PlacesList;
                console.log(DbList)
            setdataSource(DbList);});
    }
    useEffect(  () => {
        onGetAll();
    }, []);

    const onMarkClick = (iter) =>{
        Modal.confirm({
            title: "Добавить в избранное?",
            okText: "Да",
            okType: "primary",
            cancelText: "Нет",
            onOk: async () => {
                console.log(iter.id);
              await axios
                .post("http://localhost:8081/mark",{
                    title: iter.title,
                    description: iter.description,
                    place_id: iter.id,
                    label:'like',
                }, {
                  headers: {
                    token: localStorage.getItem("token"),
                  },
                })
                .then(async (res) => {
                console.log(localStorage.getItem("token"));
                console.log(res.status);
                });
            },
          });
    }

    return(
        <div className='all_main_wrapper'>
            <div className='main_wrapper'>
            <YMaps query={{lang:'ru_RU',apikey:'ed9246e1-8358-41e9-8ba3-7d5f7872dd99'}}>
              <Map
                  className="map" state={{center: [43.695, 40.317],
                  zoom: 9,
                  controls:[],
              }} >
                  <GeolocationControl options={{float:"left"}}/>
                  <SearchControl options={{float:"right",provider:'yandex#search'}}/>
                  <ZoomControl options={{size:'small' , position:{bottom:150, left:10}}}/>

                  {dataSource?.map((iter)=>(
                      <Placemark
                          geometry={[iter.pointlan,iter.pointlon]}
                          onClick={()=>{onMarkClick(iter)}}
                          options={{
                              iconImageSize:[40,40],
                              iconImageOffset:[25,-50],
                              iconLayout:'default#image',
                              iconImageHref:'https://img.icons8.com/?size=512&id=Uw5eqarvvCEu&format=png',
                          }}
                          properties={{
                              hintContent:'<b>ass</b>',
                              balloonContentHeader: iter.title,
                              balloonContent: iter.description
                          }}
                      />
                  ))}
              </Map>
            </YMaps>
            </div>

            <div className='main_link_box'>
                <div className='link_wrapper'>
                    <img className='link_icon' src='../../icon-user.svg'/>
                    <Link to='/profile' className='main_link'>Профиль</Link>
                </div>
                <div className='link_wrapper'>
                    <img className='link_icon' src='../../icon-search.svg'/>
                    <Link to='/search' className='main_link'>Поиск</Link>
                </div>
            </div>    
      </div>
    )
}

export default Main;