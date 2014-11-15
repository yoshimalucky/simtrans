#!/bin/sh

CMD="python -m simtrans.cli"
OPENHRP_MODEL="/usr/local/share/OpenHRP-3.1/sample/model"

# fetch the drc_practice_* models from gazebo model database
#python -m simtrans.gzfetch -f tests/models.txt

# convert from urdf to wrl
python -m simtrans.catxml package://atlas_description/urdf/atlas_v3.urdf package://multisense_sl_description/urdf/multisense_sl_v3.urdf > /tmp/atlas.urdf
$CMD -i /tmp/atlas.urdf -o /tmp/atlas.wrl

rosrun xacro xacro.py `rospack find pr2_description`/robots/pr2.urdf.xacro > /tmp/pr2.urdf
$CMD -i /tmp/pr2.urdf -o /tmp/pr2.wrl

# convert from sdf to wrl
for i in `cat tests/models.txt`; do
$CMD -i model://$i/model.sdf -o /tmp/$i.wrl
done

# convert from wrl to sdf
if [ -f $HOME/HRP-4C/HRP4Cmain.wrl ]; then
$CMD -i $HOME/HRP-4C/HRP4Cmain.wrl -o $HOME/.gazebo/models/hrp4c.world
fi
$CMD -i $OPENHRP_MODEL/PA10/pa10.main.wrl -o $HOME/.gazebo/models/pa10.world
$CMD -i $OPENHRP_MODEL/closed-link-sample.wrl -o $HOME/.gazebo/models/closed-link-sample.world
$CMD -i $OPENHRP_MODEL/house/house.main.wrl -o $HOME/.gazebo/models/house.world
$CMD -i $OPENHRP_MODEL/crawler.wrl -o $HOME/.gazebo/models/crawler.world
$CMD -i $OPENHRP_MODEL/simple_vehicle_with_camera.wrl -o $HOME/.gazebo/models/simple_vehicle_with_camera.world
$CMD -i $OPENHRP_MODEL/simple_vehicle_with_rangesensor.wrl -o $HOME/.gazebo/models/simple_vehicle_with_rangesensor.world
