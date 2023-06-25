import { Switch } from "antd";
import { Button, Modal, Table, Input } from "antd";
import { useState, useEffect } from "react";
import { EditOutlined, DeleteOutlined } from "@ant-design/icons";
import axios, { Axios } from "axios";

function ToDoTable() {
  const [visibleEdit, setvisibleEdit] = useState(false);
  const [valueInputEdit, setvalueInputEdit] = useState(null);
  const [visibleAdd, setvisibleAdd] = useState(false);
  const [valueInputAdd, setvalueInputAdd] = useState(null);
  const coloms = [
    {
      key: "1",
      title: "TITLE",
      dataIndex: "title",
    },
    {
      key: "2",
      title: "DESCRIPTION",
      dataIndex: "description",
    },
    {
      key: "3",
      title: "ACTION",
      render: (record) => {
        return (
          <>
            <EditOutlined
              onClick={() => {
                editOn(record);
              }}
            />
            <DeleteOutlined
              onClick={() => {
                onDeleteToDo(record);
              }}
              style={{ color: "red", marginLeft: 12 }}
            />
          </>
        );
      },
    },
  ];

  const [dataSource, setdataSource] = useState();
  const getReq = async () => {
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
  };

  useEffect(() => {
    getReq();
  }, []);

  const onDeleteToDo = (record) => {
    Modal.confirm({
      title: "Вы уверены?",
      okText: "Так точно",
      okType: "danger",
      cancelText: "Я случайно",
      onOk: async () => {
        await axios
          .delete("http://localhost:8081/" + record.id, {
            headers: {
              token: localStorage.getItem("token"),
            },
          })
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
      },
    });
  };
  const onDeleteAll = () => {
    Modal.confirm({
      title: "Вы уверены?",
      okText: "Так точно",
      okType: "danger",
      cancelText: "Я случайно",
      onOk: async () => {
        await axios
          .delete("http://localhost:8081/", {
            headers: {
              token: localStorage.getItem("token"),
            },
          })
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
        console.log(localStorage.getItem("token"));
      },
    });
  };

  const editOn = (record) => {
    console.log("sw");
    setvisibleEdit(true);
    setvalueInputEdit({ ...record }); //copy record
  };

  const addOff = () => {
    setvisibleAdd(false);
    setvalueInputAdd(null);
  };

  const editOff = () => {
    setvisibleEdit(false);
    setvalueInputEdit(null);
  };

  return (
    <div className="todotable">
      <Table columns={coloms} dataSource={dataSource}></Table>
      <Button
        onClick={() => {
          setvisibleAdd(true);
        }}
      >
        Добавить
      </Button>
      <Button
        onClick={() => {
          onDeleteAll();
        }}
      >
        Удалить все
      </Button>
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
  );
}

export default ToDoTable;
