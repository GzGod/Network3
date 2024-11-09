#!/bin/bash

stty sane

tput reset
tput civis

INSTALLATION_PATH="$HOME/blockmesh"

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

exit_script() {
    show_red "脚本已停止"
    echo ""
    exit 0
}

incorrect_option () {
    echo ""
    show_red "无效的选项。请选择可用的选项。"
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "成功"
        echo ""
    else
        sleep 1
        echo ""
        show_red "失败"
        echo ""
    fi
}

run_commands_info() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "成功"
        echo ""
    else
        sleep 1
        echo ""
        show_blue "未找到"
        echo ""
    fi
}

run_node_command() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        show_green "节点已启动!"
        echo
    else
        show_red "节点未启动!"
        echo
    fi
}

show_orange " ┏━┓┏━┳┓╋┏┳━━━┳━━━┳━━━┳━━━┓" && sleep 0.2
show_orange " ┗┓┗┛┏┫┃╋┃┃┏━━┫┏━┓┃┏━┓┃┏━┓┃" && sleep 0.2
show_orange " ╋┗┓┏┛┃┃╋┃┃┗━━┫┃╋┗┫┃╋┃┃┃╋┃┃ " && sleep 0.2
show_orange " ╋┏┛┗┓┃┃╋┃┃┏━━┫┃┏━┫┗━┛┃┃╋┃┃ " && sleep 0.2
show_orange " ┏┛┏┓┗┫┗━┛┃┗━━┫┗┻━┃┏━┓┃┗━┛┃ " && sleep 0.2
show_orange " ┗━┛┗━┻━━━┻━━━┻━━━┻┛╋┗┻━━━┛" && sleep 0.2
show_orange " 我的推特雪糕战神@Hy78516012，免费开源请勿相信收费！" && sleep 0.2
echo
sleep 1

while true; do
    show_green "----- 主菜单 -----"
    echo "1. 安装"
    echo "2. 日志"
    echo "3. 启动/重启/停止"
    echo "4. 删除"
    echo "5. 节点数据"
    echo "6. 退出"
    echo ""
    echo -n "请选择一个选项: "
    read option
    echo "你选择了: $option"  # 调试信息

    case $option in
        1)
            process_notification "开始安装..."
            echo

            # Update packages
            process_notification "更新包..."
            run_commands "sudo apt update && sudo apt upgrade -y && apt install tar net-tools"

            process_notification "创建文件夹..."
            run_commands "mkdir -p $HOME/network3 && cd $HOME/network3"

            process_notification "下载..."
            run_commands "wget -O ubuntu-node-latest.tar https://network3.io/ubuntu-node-v2.1.0.tar"

            process_notification "解压..."
            run_commands "tar -xvf ubuntu-node-latest.tar && rm ubuntu-node-latest.tar"

            echo
            show_green "----- 完成! ------"
            echo
            ;;
        2)
            # Logs
            MY_IP=$(hostname -I | awk '{print $1}')
            process_notification "点击 -> https://account.network3.ai/main?o=$MY_IP:8080"
            ;;
        3)
            echo
            show_orange "请选择"
            echo
            echo "1. 启动"
            echo "2. 停止"
            echo
            echo -n "请选择一个选项: "
            read option
            echo "你选择了: $option"  # 调试信息
            case $option in
                1)
                    # Start
                    process_notification "启动中..."
                    run_node_command "cd $HOME/network3/ubuntu-node/ && ./manager.sh up"
                    echo
                    ;;
                2)
                    process_notification "停止中..."
                    run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
                    echo
                    ;;
                *)
                    incorrect_option
                    ;;
            esac
            ;;
        4)
            # Delete
            process_notification "删除节点"
            echo
            process_notification "停止中..."
            run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh down"
            echo
            process_notification "删除文件..."
            run_commands "rm -rvf $HOME/network3"
            echo
            show_green "--- 节点已删除 ---"
            echo
            ;;
        5)
            # node data
            process_notification "查找中..."
            show_green "您的节点密钥"
            run_commands_info "cd $HOME/network3/ubuntu-node/ && ./manager.sh key"
            ;;
        6)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
