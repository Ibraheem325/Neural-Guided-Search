(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	infrared0 - mode
	thermograph1 - mode
	Star1 - direction
	Star3 - direction
	Star5 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star13 - direction
	Star15 - direction
	Star16 - direction
	GroundStation18 - direction
	Star20 - direction
	Star24 - direction
	Star25 - direction
	Star26 - direction
	GroundStation30 - direction
	GroundStation33 - direction
	GroundStation37 - direction
	GroundStation39 - direction
	Star40 - direction
	Star41 - direction
	GroundStation45 - direction
	Star46 - direction
	GroundStation27 - direction
	GroundStation42 - direction
	GroundStation0 - direction
	Star7 - direction
	Star43 - direction
	Star14 - direction
	GroundStation23 - direction
	GroundStation22 - direction
	GroundStation19 - direction
	GroundStation2 - direction
	GroundStation32 - direction
	Star17 - direction
	Star6 - direction
	Star4 - direction
	GroundStation31 - direction
	GroundStation36 - direction
	Star12 - direction
	GroundStation34 - direction
	GroundStation35 - direction
	Star21 - direction
	Star8 - direction
	Star44 - direction
	Star29 - direction
	GroundStation47 - direction
	Star38 - direction
	Star28 - direction
	Star48 - direction
	Phenomenon49 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star43)
	(calibration_target instrument0 GroundStation36)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation19)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation34)
	(calibration_target instrument0 GroundStation42)
	(calibration_target instrument0 GroundStation23)
	(calibration_target instrument0 GroundStation27)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star14)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star16)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star17)
	(calibration_target instrument2 GroundStation32)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 Star28)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 GroundStation23)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star16)
	(supports instrument3 infrared0)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star28)
	(calibration_target instrument3 Star38)
	(calibration_target instrument3 GroundStation47)
	(calibration_target instrument3 Star29)
	(calibration_target instrument3 Star44)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star21)
	(calibration_target instrument3 GroundStation35)
	(calibration_target instrument3 GroundStation34)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 GroundStation36)
	(calibration_target instrument3 GroundStation31)
	(calibration_target instrument3 Star4)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star12)
)
(:goal (and
	(pointing satellite0 Star25)
	(have_image Star48 infrared0)
	(have_image Phenomenon49 thermograph1)
))

)
