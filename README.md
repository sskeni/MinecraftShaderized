# MinecraftShaderized

### Goals for the shaders

- Add lighting based on sun/moon position
- Add shadows
- Add tonemaps
- Add wavy water

### Progress Screenshots

#### Internal Shaders
![](/screenshots/InternalShaders.png)
These are the internal shaders for the game, or how the game looks without any shaders applied.

#### Light Based on the Sun Position
![](/screenshots/LightBasedOnSunPosition.png)
Here you can see the sides of blocks have different levels of light. This is especially apparent on the grass to the right. They are now taking in the position of the sun and displaying light accordingly. This is also calculated when it is night time. Ambient light is also applied here.

#### Torch Lighting (And Other Light Blocks)
![](/screenshots/TorchLighting.png)
It might be hard to tell, but on the left there is lava that is now being lit with an orange light. A picture further down shows this off better.

#### Shadows
![](/screenshots/Shadows.png)
Shadows are the main reason I did this project in the first place. I really wanted to learn how this was done. It involved calculating the world position, and using the depth buffer of the light position to calculate what is in shadow and what is not. Then it simply darkens areas in shadow. There are also a few methods for smoothing the edges of shadows, including taking 9 samples around a fragment and calculating the intensity of the shadow at that point based on the samples. There is also a simple noise texture applied to blend the various fragments.

#### Night Time
![](/screenshots/Night.png)
Here is a screenshot of the above effects but during night. The moon's intensity is 1/10 of the sun's intensity, and makes for a darker scene. The torch lighting is also highlighted in this picture. Something else I wanted to bring up here is that it took a great amount of time to get water and entities (sheep, zombies, etc.) to correctly display light and shadows. This was due to the tomfoolery involved with coding shaders for Minecraft, mainly due to the lack of documentation and tutorials.
