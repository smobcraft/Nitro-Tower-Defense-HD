using UnityEngine;
using System.Collections;

public class UnitStats : MonoBehaviour {

	public float ssHP;
	public float ssDamage;
	public float fsHP;
	public float fsDamage;
	public float tankHP;
	public float tankDamage;
	public float level;
	public float score;
	public EnemySpawner es;

	// Use this for initialization
	void Start () {
		//ssHP = PlayerPrefs.GetFloat ("StandardSuitHP", 0);
		//ssDamage = PlayerPrefs.GetFloat ("StandardSuitDamage", 0);
		//fsHP = PlayerPrefs.GetFloat ("FlameSuitHP", 0);
		//fsDamage = PlayerPrefs.GetFloat ("FlameSuitDamage", 0);
		//level = PlayerPrefs.GetFloat ("Level", 1);
		es.level = level;
		es.SetSpawnRate ();
		GetComponent<UnitSpawning> ().maxResources = 3 * level;
		GetComponent<UnitSpawning> ().resources = GetComponent<UnitSpawning> ().maxResources;
	}
	
	void OnDestroy()
	{
		PlayerPrefs.SetFloat ("StandardSuitHP", ssHP);
		PlayerPrefs.SetFloat ("StandardSuitDamage", ssDamage);
		PlayerPrefs.SetFloat ("FlameSuitHP", fsHP);
		PlayerPrefs.SetFloat ("FlameSuitDamage", fsDamage);
		PlayerPrefs.SetFloat ("Level", level);
	}


}
