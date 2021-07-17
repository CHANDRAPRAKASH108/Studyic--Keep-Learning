import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
var color;
class SocialCard extends StatelessWidget {
  String uploader,name,captions,linkimage;
  bool is_images;
  SocialCard({required this.uploader,required this.name,required this.captions,required this.linkimage,required this.is_images});
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(uploader),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.035),),
          Text(captions,style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.03),)
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          is_images? Container(
            width: MediaQuery.of(context).size.width*0.7,
            height: MediaQuery.of(context).size.height*0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: CachedNetworkImage(
              imageUrl: linkimage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,),
                ),
              ),
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ):Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Theme.of(context).primaryColor)
            ),
            width: MediaQuery.of(context).size.width*0.7,
            height: MediaQuery.of(context).size.height*0.5,
            child: Center(child: Text(linkimage,style: TextStyle(fontWeight: FontWeight.bold),)),
          ),
          const SizedBox(height: 5.0,),
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    color = Colors.red;
                  },
                  child: Icon(Icons.favorite)),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Divider()
          )],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
    );
  }
}
