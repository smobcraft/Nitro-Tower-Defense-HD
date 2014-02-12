using UnityEngine;
using System.Collections;

public class CaveAndShipHPBars : MonoBehaviour {

	public GUITexture cave;
	public GUITexture ship;
	public GUITexture ss;
	public GUITexture fs;
	public GUITexture tank;
	public GUITexture up;
	public GUITexture down;

	float up2InsetY;
	float up2InsetX;

	float fire1InsetX;
	float fire1InsetY;
	float fire2InsetX;
	float fire2InsetY;
	float thrustInsetX;
	float thrustInsetY;
	float upInsetX;
	float upInsetY;
	float downInsetX;
	float downInsetY;
	float screenRatio;
	float screenRatioX;

	public Texture healthBarColor;

	public GameObject caveObj;
	public GameObject shipObj;

	UnitSpawning us;

	string resources;
	string resourcesMax;
	float caveMaxHP;
	float caveCurrent;
	float shipMax;
	float shipCurrent;

	float nativeX = 1920f;
	float nativeY = 1080f;

	public Font myFont;
	public int textSize;

	GameObject player;

	// Use this for initialization
	void Start () {
		player = GameObject.Find ("Player");

		//GUI STUFF
		up2InsetX = up.pixelInset.width;
		up2InsetY = up.pixelInset.height;
		fire1InsetX = cave.pixelInset.width;
		fire1InsetY = cave.pixelInset.height;
		fire2InsetX = ship.pixelInset.width;
		fire2InsetY = ship.pixelInset.height;
		thrustInsetX = ss.pixelInset.width;
		thrustInsetY = ss.pixelInset.width;
		upInsetX = fs.pixelInset.width;
		upInsetY = fs.pixelInset.width;
		downInsetX = tank.pixelInset.width;
		downInsetY = tank.pixelInset.width;

		screenRatio = Screen.height * (1 / nativeY);
		screenRatioX = Screen.width * (1 / nativeX);

		resizeButton (up, up2InsetX, up2InsetY, screenRatio);
		resizeButton (down, up2InsetX, up2InsetY, screenRatio);

		resizeButton (cave, fire1InsetX, fire1InsetY, screenRatio);
		resizeButton (ship, fire2InsetX, fire2InsetY, screenRatio);
		resizeButton (ss, thrustInsetX, thrustInsetY, screenRatio);
		resizeButton (fs, upInsetX, upInsetY, screenRatio);
		resizeButton (tank, downInsetX, downInsetY, screenRatio);


		us = GameObject.Find ("Player").GetComponent<UnitSpawning> ();
		caveMaxHP = caveObj.GetComponent<Health> ().maxHP;
		caveCurrent = caveObj.GetComponent<Health> ().currentHP;
		shipMax = shipObj.GetComponent<Health> ().maxHP;
		shipCurrent = shipObj.GetComponent<Health> ().currentHP;
		resourcesMax = Mathf.FloorToInt(us.maxResources).ToString ();


	}
	
	// Update is called once per frame
	void Update () {
		resources = Mathf.FloorToInt(us.resources).ToString ();
		shipCurrent = shipObj.GetComponent<Health> ().currentHP;
		caveCurrent = caveObj.GetComponent<Health> ().currentHP;
		for (int i = 0; i < Input.touchCount; i++)
		{
			
			if (ss.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					ss.GetComponent<SpawnUnit>().SpawnUnitTouch();
				}
			}
			if (fs.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					fs.GetComponent<SpawnUnit>().SpawnUnitTouch();
				}
			}
			if (tank.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					tank.GetComponent<SpawnUnit>().SpawnUnitTouch();
				}
			}

			if (up.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					player.GetComponent<CameraMover>().moveUp = 1;
				}
				if (Input.GetTouch(i).phase == TouchPhase.Ended || Input.GetTouch(i).phase == TouchPhase.Canceled)
				{
					player.GetComponent<CameraMover>().moveUp = 0;
				}
			}

			if (down.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					player.GetComponent<CameraMover>().moveDown = 1;
				}
				if (Input.GetTouch(i).phase == TouchPhase.Ended || Input.GetTouch(i).phase == TouchPhase.Canceled)
				{
					player.GetComponent<CameraMover>().moveDown = 0;
				}
			}

		}
	}
	
	void OnGUI()
	{
		GUIStyle myStyle = new GUIStyle ();
		myStyle.font = myFont;
		myStyle.fontSize = Mathf.CeilToInt(textSize* screenRatio);
		myStyle.normal.textColor = new Color (1, 1, 1);
		GUI.DrawTexture (new Rect (1450 * screenRatioX, 130 * screenRatio, caveCurrent / caveMaxHP * 400* screenRatioX, 30 * screenRatio), healthBarColor);
		GUI.DrawTexture (new Rect (30* screenRatioX, 130 * screenRatio, shipCurrent / shipMax * 400* screenRatioX, 30 * screenRatio), healthBarColor);
		GUILayout.Label ("Current Resources: " + resources + "/" + resourcesMax,myStyle);
	}
	void resizeButton( GUITexture text, float width, float height, float ratio)
	{
		text.pixelInset = new Rect (0, 0, width * ratio, height * ratio);
	}
}
