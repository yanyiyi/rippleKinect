void back1(int t)
{


    if (t>5)
    {
        currentFrame1 = (currentFrame1+1) % numFrames1;  
        image(back1[currentFrame1 % numFrames1], 0, 0);
    }
}

void back2(int t)
{
    if (t<=5)
    {
        currentFrame2 = (currentFrame2+1) % numFrames2;  
        image(back2[currentFrame2 % numFrames2], 0, 0);
    }
}