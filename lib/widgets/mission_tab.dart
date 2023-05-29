import 'package:flutter/material.dart';

class MissionTab extends StatefulWidget {
  const MissionTab({Key? key}) : super(key: key);

  @override
  State<MissionTab> createState() => _MissionTabState();
}

class _MissionTabState extends State<MissionTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: PageView(
        controller: PageController(
          initialPage: 0,
          keepPage: true,
        ),
        children: [
          Image(
            image: AssetImage('assets/image/alley.jpg'),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Text('프롤로그', style: TextStyle(fontSize: 28, color: Colors.white),),
                SizedBox(height: 10,),
                Text('어두운 밤하늘에 수많은 빛이 깜빡이는 도시의 광경이 나타났다. 높은 건물과 번화한 거리, 그리고 차들이 오가는 소리가 내 귀에 들려왔다. 이 도시는 언제나 바쁘고 끊임없는 움직임이 일어나고 있었다. 그러나 이번 밤, 나는 그것들 모두보다 더 큰 움직임이 일어날 것을 예상하며 이곳에 온 것이었다.', style: TextStyle(fontSize: 18, color: Colors.white),),
                SizedBox(height: 10,),
                Text('발걸음을 멈추어 멀리서 한 대의 차가 다가오는 소리를 들었다. 차가 가까워질수록 그 소리는 점점 더 크고 날카로워졌다. 그리고 마침내 그 차는 나와 끝없이 이어지는 거리를 따라 달려나갔다. 그 순간, 내 마음속에서는 무언가 큰 사건이 일어날 것이라는 예감이 들었다.', style: TextStyle(fontSize: 18, color: Colors.white),),
                SizedBox(height: 10,),
                Text('나는 다시 걷기 시작했다. 도시의 어둠 속에서, 내 앞길에는 무엇이 기다리고 있는지 모르는 상황이 나를 불안하게 만들었다. 그리고 언제나 그랬듯이, 내 예감은 맞았다. 나의 시선은 비추어진 빛들과 함께 도시의 어둠에서 솟아오르는 불꽃을 발견했다. 무언가 큰 사건이 일어난 것 같았다.', style: TextStyle(fontSize: 18, color: Colors.white),),

              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mission 1 \n살인 장소로 찾아가라.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              'Mission 3',
            ),
          ),
        ],
      ),
    );
  }
}
