using UnityEngine;
using System.Collections;

public class Health : MonoBehaviour {
	
	public float currentHP;
	public float maxHP;
	public GameObject deathPrefab;
	public UnitStats player;
	public float points;
	public AudioClip deathSound;
	
	// Use this for initialization
	void Start () {
		player = GameObject.Find ("Player").GetComponent<UnitStats> ();
		currentHP = maxHP;
	}
	
	// Update is called once per frame
	void Update () {
		if (currentHP <= 0)
		{
			Die();
		}
	}
	
	public void DealDamage(float amt)
	{
		currentHP -= amt;
	}
	
	void Die()
	{
		if (this.name == "Colony Nexus" || this.name == "Empire Nexus")
			Application.LoadLevel("Level0");
		player.score += points;
		if (deathSound != null)
		{
			AudioSource.PlayClipAtPoint (deathSound, Camera.main.transform.position);
		}

		Destroy (this.gameObject);
		if (deathPrefab != null)
		{
			Instantiate(deathPrefab, transform.position, transform.rotation);
		}

	}
}
