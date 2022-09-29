#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <fcntl.h>
#include <unistd.h>
#include <linux/joystick.h>


char *jsDevice(){
    return "/dev/input/js0";
}

struct axis_state {
    int axis;
    int x, y;
};

struct buttons{
    int number;
    int value;
};

int read_event(int fd, struct js_event *event)
{
    ssize_t bytes;

    bytes = read(fd, event, sizeof(*event));

    if (bytes == sizeof(*event))
        return 0;

    /* Error, could not read full event. */
    return -1;
}

size_t get_button_count(int fd)
{
    __u8 buttons;
    if (ioctl(fd, JSIOCGBUTTONS, &buttons) == -1)
        return 0;

    return buttons;
}

size_t get_axis_state(struct js_event *event, struct axis_state *axes)
{
    size_t axis = event->number / 2;

    if (axis < 3)
    {   
        if (event->number % 2 == 0)
            axes->x = event->value;
        else
            axes->y = event->value;
        axes->axis=axis;
    }

    return axis;
}

size_t get_axis_count(int fd)
{
    __u8 axes;

    if (ioctl(fd, JSIOCGAXES, &axes) == -1)
        return 0;

    return axes;
}




struct axis_state axes(){
    struct js_event event;
    struct axis_state axes;
    size_t axis;

    int js;

    js = open("/dev/input/js0", O_RDONLY);

    while (read_event(js, &event) == 0)
    {
        switch (event.type)
        {
            case JS_EVENT_AXIS:
                axis = get_axis_state(&event, &axes);
                if (axis < 3)
                    axes.axis=axis;
                    axes.x=axes.x;
                    axes.y=axes.y;
                    return axes;

                break;
            default:
                /* Ignore init events. */
                break;
        }
        
        fflush(stdout);
    }

    close(js);

}

struct buttons button(){
    struct js_event event;
    struct buttons button;
    int js;

    js = open("/dev/input/js0", O_RDONLY);
    
     while (read_event(js, &event) == 0)
    {
        // printf(js);
        switch (event.type)
        {
            case JS_EVENT_BUTTON:
                // printf("Button %u %s\n", event.number, event.value ? "pressed" : "released");
                button.number=event.number;
                button.value=event.value;
                return button;
                
                break;
            default:
                /* Ignore init events. */
                break;
        }
        
        fflush(stdout);
    }

    close(js);
}

int main(){
    
}