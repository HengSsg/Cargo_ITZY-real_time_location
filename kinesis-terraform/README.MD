# Getting Start

## Prerequisites
- `AWS CLI`설치 후 `configure`을 완료해야 합니다.
- `terraform`이 설치되어 있어야 합니다.

## 1. Local apply
1. `git clone https://github.com/cs-devops-bootcamp/devops-01-Final-TeamE-cargoitzy.git`
4. ./main.tf 의 line.50(버킷 이름)을 변경 해주세요,
그리고 `provider`를 아래의 것으로 바꾸어 주세요
```
  # local test provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.74.2"
    }
  }
  #
```
5. `terraform init`을 해주세요
6. `terraform plan`입력과 엔터 두번을 눌러주세요
7. `terraform apply` 후 username 과 password를 입력해주세요
### Output
<img width="1029" alt="image" src="https://user-images.githubusercontent.com/97237728/172280238-cfe00001-4417-4b48-a4c0-7bec7782a947.png">


`apply`후 `outputs`에서 `invoke_url`의 주소를 카피해서 요청바디(json)와 함께 `POST`를 해주세요

## Clean UP
- `terraform destroy` 입력후 엔터 두 번으로 변수설정 부분 스킵.

## 2. Github action apply
1. <img width="781" alt="image" src="https://user-images.githubusercontent.com/97237728/172281694-ae35dec0-3b6a-43a6-b79d-efbb1c4a09e5.png">
`terraform cloud` 의 `TF_API_TOKEN`을 설정 해주세요.
1. /.github/workflows/terraform.yml 파일의 주석을 제거 해주세요.
2. `main branch`에 푸쉬를 해주세요
3. Github Action이 실행이 완료되면 AWS 콘솔에서 확인 해주세요

## Clean UP
 terraform cloud에서 resource들을 제거 해주세요
 <img width="755" alt="image" src="https://user-images.githubusercontent.com/97237728/172282671-c10bd6c2-771c-4feb-9d43-b943c0091fc0.png">

