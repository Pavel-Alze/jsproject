import { Button, Modal, Table, Input } from "antd";
import { useState, useEffect } from "react";
import { SolutionOutlined, DeleteOutlined, FrownOutlined, SmileOutlined } from "@ant-design/icons";
import axios, { Axios } from "axios";
import { useNavigate } from "react-router-dom";

function SearchPage(){
  const navigate=useNavigate();
  const [visibleEdit, setvisibleEdit] = useState(false);
  const [valueInputEdit, setvalueInputEdit] = useState(null);
  const [visibleAdd, setvisibleAdd] = useState(false);
  const [valueInputAdd, setvalueInputAdd] = useState(null);
  const coloms = [
    {
      key: "1",
      dataIndex: "title",
    },
    {
      key: "2",
      dataIndex: "description",
    },
    {
        key: "3",
        render: (record) => {
          return (
            <>
              <SolutionOutlined
                onClick={() => {
                  onReviewClick();
                }}
                style={{ color: "red", marginLeft: 12 }}
              />

                <SmileOutlined 
                    onClick={() => {
                    onFavoritesAdd(record);
                        }}
                    style={{ color: "red", marginLeft: 12 }}
                />

              <FrownOutlined 
                  onClick={() => {
                    onBlacklistAdd(record);
                  }}
                  style={{ color: "red", marginLeft: 12 }}
              />
            </>
          );
        },
      }
  ];

  const [dataSource, setdataSource] = useState();
  const [dataSource2, setdataSource2] = useState();
  const [dataSource3, setdataSource3] = useState();
  const getReq = async () => {
    await axios
      .get("http://localhost:8081/places", {
        headers: {
          token: localStorage.getItem("token"),
        },
      })
      .then((res) => {
        const allPersons = res.data.PlacesList;
        setdataSource(allPersons);
      });
  };

  const getReq2 = async () => {
    await axios
      .get("http://localhost:8081/mark/blacklist", {
        headers: {
          token: localStorage.getItem("token"),
        },
      })
      .then((res) => {
        const allPersons = res.data.PlacesList;
        setdataSource2(allPersons);
      });
  };

  const getReq3 = async () => {
    await axios
      .get("http://localhost:8081/user", {
        headers: {
          token: localStorage.getItem("token"),
        },
      })
      .then((res) => {
        const allPersons = res.data.user;
        setdataSource3(allPersons);
      });
  };

  useEffect(() => {
    getReq();
    getReq2();
    getReq3();
  }, []);

  const addOff = () => {
    setvisibleAdd(false);
    setvalueInputAdd(null);
  };

  const editOff = () => {
    setvisibleEdit(false);
    setvalueInputEdit(null);
  };

  const onReviewClick = () =>{
    navigate("/review")
  }

  const onFavoritesAdd = (record) =>{
    Modal.confirm({
      title: "Добавить в избранное?",
      okText: "Да",
      okType: "danger",
      cancelText: "Нет",
      onOk: async () => {
        await axios
          .post("http://localhost:8081/mark",{place_id:record.id, label:'like'}, {
            headers: {
              token: localStorage.getItem("token"),
            },
          })
          .then(async () => {
            getReq();
            getReq2();
          });
      },
    });
  }

  const onBlacklistAdd = (record) =>{
    Modal.confirm({
      title: "Добавить в черный список?",
      okText: "Да",
      okType: "danger",
      cancelText: "Нет",
      onOk: async () => {
        await axios
          .post("http://localhost:8081/mark",{place_id:record.id, label:'blacklist'}, {
            headers: {
              token: localStorage.getItem("token"),
            },
          })
          .then(async () => {
            getReq();
            getReq2();
          });
      },
    });
  }


    return(
        <div className="search_wrapper">
          <div className="search_table_wrapper">
          <Table columns={coloms} dataSource={dataSource}></Table>
            <Modal
                title="Add ToDo"
                visible={visibleAdd}
                onCancel={() => {
                addOff();
                }}
                okText="Сохранить"
                onOk={async () => {
                await axios
                    .post(
                    "http://localhost:8081/",
                    {
                        title: valueInputAdd.title,
                        description: valueInputAdd.description,
                    },
                    {
                        headers: {
                        token: localStorage.getItem("token"),
                        },
                    }
                    )
                    .then(
                    async () =>
                        await axios
                        .get("http://localhost:8081/", {
                            headers: {
                            token: localStorage.getItem("token"),
                            },
                        })
                        .then((res) => {
                            const allPersons = res.data;
                            setdataSource(allPersons);
                        })
                    );

                addOff();
                }}
            >
                <Input
                value={valueInputAdd?.title}
                onChange={(e) => {
                    setvalueInputAdd((pre) => {
                    return { ...pre, title: e.target.value };
                    });
                }}
                />
                <Input
                value={valueInputAdd?.description}
                onChange={(e) => {
                    setvalueInputAdd((pre) => {
                    return { ...pre, description: e.target.value };
                    });
                }}
                />
            </Modal>
            <Modal
                title="Edit ToDo"
                visible={visibleEdit}
                onCancel={() => {
                editOff();
                }}
                okText="Сохранить"
                onOk={async () => {
                console.log(valueInputEdit.id);
                await axios
                    .patch(
                    "http://localhost:8081/" + valueInputEdit.id,
                    {
                        title: valueInputEdit.title,
                        description: valueInputEdit.description,
                    },
                    {
                        headers: {
                        token: localStorage.getItem("token"),
                        },
                    }
                    )
                    .then(async () => {
                    await axios
                        .get("http://localhost:8081/", {
                        headers: {
                            token: localStorage.getItem("token"),
                        },
                        })
                        .then((res) => {
                        const allPersons = res.data;
                        setdataSource(allPersons);
                        });
                    });

                editOff();
                }}
            >
                <Input
                value={valueInputEdit?.title}
                onChange={(e) => {
                    setvalueInputEdit((pre) => {
                    return { ...pre, title: e.target.value };
                    });
                }}
                />
                <Input
                value={valueInputEdit?.description}
                onChange={(e) => {
                    setvalueInputEdit((pre) => {
                    return { ...pre, description: e.target.value };
                    });
                }}
                />
            </Modal>
          </div>
        </div>
    )
}
export default SearchPage;