docker build -q -t add .
docker run --rm --name add -d -p 8080:8080 add

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"opcode":128,"state":{"a":46,"b":108,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":1,"stackPointer":2,"cycles":0}}' \
  http://localhost:8080/api/v1/execute`
EXPECTED='{"opcode":128,"state":{"a":154,"b":108,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":true,"zero":false,"auxCarry":true,"parity":true,"carry":false},"programCounter":1,"stackPointer":2,"cycles":4}}'

docker kill add

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mADD Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mADD Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi