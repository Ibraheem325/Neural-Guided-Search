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
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	infrared2 - mode
	thermograph1 - mode
	thermograph0 - mode
	infrared3 - mode
	GroundStation2 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation17 - direction
	Star18 - direction
	GroundStation25 - direction
	GroundStation20 - direction
	Star23 - direction
	GroundStation19 - direction
	Star4 - direction
	Star24 - direction
	GroundStation0 - direction
	GroundStation16 - direction
	GroundStation15 - direction
	GroundStation3 - direction
	GroundStation21 - direction
	GroundStation1 - direction
	Star6 - direction
	Star7 - direction
	Star22 - direction
	Phenomenon26 - direction
	Phenomenon27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Phenomenon31 - direction
	Star32 - direction
	Planet33 - direction
	Planet34 - direction
	Planet35 - direction
	Phenomenon36 - direction
	Star37 - direction
	Star38 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 GroundStation19)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star22)
	(calibration_target instrument0 Star23)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation20)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 GroundStation15)
	(calibration_target instrument2 Star24)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star38)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet33)
	(supports instrument4 infrared2)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation21)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 GroundStation15)
	(calibration_target instrument4 GroundStation16)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation10)
	(supports instrument5 thermograph0)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star22)
	(calibration_target instrument5 Star7)
	(calibration_target instrument5 Star6)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation16)
)
(:goal (and
	(pointing satellite0 GroundStation19)
	(pointing satellite1 Star7)
	(pointing satellite2 GroundStation25)
	(pointing satellite3 Phenomenon31)
	(pointing satellite4 GroundStation16)
	(have_image Phenomenon26 infrared2)
	(have_image Phenomenon27 infrared2)
	(have_image Star28 infrared2)
	(have_image Phenomenon29 infrared3)
	(have_image Planet30 thermograph0)
	(have_image Phenomenon31 infrared2)
	(have_image Star32 infrared3)
	(have_image Planet33 thermograph1)
	(have_image Planet34 thermograph1)
	(have_image Planet35 thermograph1)
	(have_image Phenomenon36 thermograph0)
	(have_image Star37 thermograph0)
	(have_image Star38 thermograph1)
))

)
