import { Button, Modal, Table, Input } from "antd";
import { useState, useEffect } from "react";
import { FrownOutlined, DeleteOutlined, SolutionOutlined, SmileOutlined} from "@ant-design/icons";
import axios, { Axios } from "axios";
import { useNavigate } from "react-router-dom";

function Profile(){
  const navigate=useNavigate();
  const [visibleEdit, setvisibleEdit] = useState(false);
  const [valueInputEdit, setvalueInputEdit] = useState(null);
  const [visibleAdd, setvisibleAdd] = useState(false);
  const [valueInputAdd, setvalueInputAdd] = useState(null);
  const coloumns1 = [
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
            <DeleteOutlined
              onClick={() => {
                onDeleteToDo(record);
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
    },
  ];
  const coloumns2 = [
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
      title: "",
      render: (record) => {
        return (
          <>
          <SolutionOutlined 
              onClick={() => {
                onDeleteToDo(record);
              }}
              style={{ color: "red", marginLeft: 12 }}
            
            />

            <DeleteOutlined
              onClick={() => {
                onDeleteToDo(record);
              }}
              style={{ color: "red", marginLeft: 12 }}
            />

            <SmileOutlined 
              onClick={() => {
                onFavoritesAdd(record);
              }}
              style={{ color: "red", marginLeft: 12 }}
            />
          </>
        );
      },
    },
  ];

  const [dataSource, setdataSource] = useState();
  const [dataSource2, setdataSource2] = useState();
  const [dataSource3, setdataSource3] = useState();
  const getReq = async () => {
    await axios
      .get("http://localhost:8081/mark/like", {
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

  const onDeleteToDo = (record) => {
    Modal.confirm({
      title: "Вы уверены?",
      okText: "Так точно",
      okType: "danger",
      cancelText: "Я случайно",
      onOk: async () => {
        await axios
          .patch("http://localhost:8081/mark",{place_id:record.place_id,label:'none'}, {
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
          .patch("http://localhost:8081/mark",{place_id:record.place_id, label:'like'}, {
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
          .patch("http://localhost:8081/mark",{place_id:record.place_id, label:'blacklist'}, {
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

  const addOff = () => {
    setvisibleAdd(false);
    setvalueInputAdd(null);
  };

  const editOff = () => {
    setvisibleEdit(false);
    setvalueInputEdit(null);
  };

    return(
        <div className="profile_wrapper">
            <div className="user_block_wrapper">
                <div className="user_block">
                    <span>Фамилия: {dataSource3?.surname}</span>
                    <span>Имя: {dataSource3?.name}</span>
                    <span>Телефон: {dataSource3?.phone}</span>
                    <span>Почта: {dataSource3?.email}</span>
                    <span>Возраст: {dataSource3?.age}</span>
                </div>
            </div>
            <div className="lists_block">
                <div className="favorites">
                <Table className="favorites_table"columns={coloumns1} dataSource={dataSource} title={()=>"Избранное"}></Table>


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

                <div className="black_list">
                <Table className="black_list_table" columns={coloumns2} dataSource={dataSource2} title={()=>"Черный список"}></Table>
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
        </div>
    )
}

export default Profile;