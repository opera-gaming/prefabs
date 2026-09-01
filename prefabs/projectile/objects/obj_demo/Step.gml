var _target = instance_find(obj_demo_target, 0);
if (_target == noone) exit;

if (keyboard_check(vk_space) && projectile_ready(cooldown)) {
    projectile_launch(obj_demo_shot, 80, 200,
        projectile_aim(80, 200, _target.x, _target.y), 9, 3);
    projectile_launch(obj_demo_shot, 80, 340,
        projectile_lead(80, 340, _target, 9), 9, 3);
}
