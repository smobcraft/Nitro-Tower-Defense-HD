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
	public GUITexture upgrade1;
	public GUITexture upgrade2;
	public GUITexture upgrade3;

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

	public GameObject upgrades;

	GameObject player;

	public Texture black;
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
		upInsetX = upgrade1.pixelInset.width;
		upInsetY = upgrade1.pixelInset.width;
		downInsetX = tank.pixelInset.width;
		downInsetY = tank.pixelInset.width;

		screenRatio = Screen.height * (1 / nativeY);
		screenRatioX = Screen.width * (1 / nativeX);

		resizeButton (up, up2InsetX, up2InsetY, screenRatio);
		resizeButton (down, up2InsetX, up2InsetY, screenRatio);

		resizeButton (cave, fire1InsetX, fire1InsetY, screenRatio);
		resizeButton (ship, fire2InsetX, fire2InsetY, screenRatio);
		resizeButton (ss, thrustInsetX, thrustInsetY, screenRatio);
		resizeButton (fs, thrustInsetX, thrustInsetY, screenRatio);
		resizeButton (tank, downInsetX, downInsetY, screenRatio);
		resizeButton (upgrade1, upInsetX, upInsetY, screenRatio);
		resizeButton (upgrade2, upInsetX, upInsetY, screenRatio);
		resizeButton (upgrade3, upInsetX, upInsetY, screenRatio);


		us = GameObject.Find ("Player").GetComponent<UnitSpawning> ();
		caveMaxHP = caveObj.GetComponent<Health> ().maxHP;
		caveCurrent = caveObj.GetComponent<Health> ().currentHP;
		shipMax = shipObj.GetComponent<Health> ().maxHP;
		shipCurrent = shipObj.GetComponent<Health> ().currentHP;
		resourcesMax = Mathf.FloorToInt(us.maxResources).ToString ();


	}
	
	// Update is called once per frame
	void Update () {
		if (player.GetComponent<UnitStats>().score >= 100)
		{
			upgrades.SetActive(true);
		}
		resourcesMax = Mathf.FloorToInt(us.maxResources).ToString ();
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

			if (upgrade1.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began && player.GetComponent<UnitStats>().score >= 100f)
				{
					player.GetComponent<UnitStats>().score -= 100f;
					player.GetComponent<UnitStats>().ssDamage+= 1f;
					player.GetComponent<UnitStats>().ssHP += 1f;
				}
			}
			if (upgrade2.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began && player.GetComponent<UnitStats>().score >= 100f)
				{
					player.GetComponent<UnitStats>().score -= 100f;
					player.GetComponent<UnitStats>().tankDamage += 5f;
					player.GetComponent<UnitStats>().tankHP+= 5f;
				}
			}
			if (upgrade3.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began && player.GetComponent<UnitStats>().score >= 100f)
				{
					player.GetComponent<UnitStats>().score -= 100f;
					player.GetComponent<UnitStats>().fsDamage += 3f;
					player.GetComponent<UnitStats>().fsHP += 2f;
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
		if (player.GetComponent<UnitStats>().score < 100)
		{
			upgrades.SetActive(false);
		}
	}
	
	void OnGUI()
	{
		GUIStyle myStyle = new GUIStyle ();
		myStyle.font = myFont;
		myStyle.fontSize = Mathf.CeilToInt(textSize* screenRatio);

		myStyle.normal.textColor = new Color (1, 1, 1);
		GUI.DrawTexture (new Rect(0,0, Screen.width, 50 * screenRatio),black);
		GUI.DrawTexture (new Rect (1450 * screenRatioX, 130 * screenRatio, caveCurrent / caveMaxHP * 400* screenRatioX, 30 * screenRatio), healthBarColor);
		GUI.DrawTexture (new Rect (30* screenRatioX, 130 * screenRatio, shipCurrent / shipMax * 400* screenRatioX, 30 * screenRatio), healthBarColor);
		GUILayout.Label ("Current Resources: " + resources + "/" + resourcesMax + "    Level:" + player.GetComponent<UnitStats>().level.ToString() + "    Score:" + player.GetComponent<UnitStats>().score.ToString(),myStyle);
	}
	void resizeButton( GUITexture text, float width, float height, float ratio)
	{
		text.pixelInset = new Rect (0, 0, width * ratio, height * ratio);
	}
}
