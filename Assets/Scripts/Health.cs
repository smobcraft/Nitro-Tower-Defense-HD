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

		if (this.name == "StandardInfantry(Clone)")
		{
			maxHP += player.ssHP;
			GetComponent<AttackScript>().damage += player.ssDamage;
		}

		if (this.name == "FlameThrower(Clone)")
		{
			maxHP += player.fsHP;
			GetComponent<FlameThrowerAttackScript>().damage += player.fsDamage;

		}

		if (this.name == "Colony Tank 1(Clone)")
		{
			maxHP += player.tankHP;
			GetComponent<AttackScript>().damage += player.tankDamage;
		}
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
		if (this.GetComponent<PathfindingScript>().enemyTarget.name == "Empire Nexus")
		{
			Debug.Log ("happened");
			if (this.name == "FlameThrower(Clone)")
			{
				this.GetComponent<FlameThrowerAttackScript>().FindTarget();
			}
			else
			{
				this.GetComponent<AttackScript>().FindTarget();
			}
		}
	}
	
	void Die()
	{
		if (this.name == "Colony Nexus" || this.name == "Empire Nexus")
		{
			if (this.name == "Empire Nexus")
				GameObject.Find ("Player").GetComponent<UnitStats>().level++;
			Application.LoadLevel("Level1");

		}
			
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
